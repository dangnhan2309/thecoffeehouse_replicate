from fastapi import APIRouter, Depends, HTTPException, status, File, UploadFile, Form
from fastapi.security import OAuth2PasswordBearer
from sqlalchemy.orm import Session
from database import get_db
from models.user import User
from schemas.auth import RegisterRequest, LoginRequest, UserUpdate
from utils.security import hash_password, verify_password
from utils.jwt import create_token, decode_token
import shutil
import os

router = APIRouter(prefix="/auth")

@router.post("/register")
def register(data: RegisterRequest, db: Session = Depends(get_db)):
    if db.query(User).filter(User.email == data.email).first():
        raise HTTPException(400, "Email đã tồn tại")

    user = User(
        email=data.email,
        password_hash=hash_password(data.password),
        full_name=data.full_name
    )
    db.add(user)
    db.commit()
    return {"message": "Register success"}

@router.post("/login")
def login(data: LoginRequest, db: Session = Depends(get_db)):
    user = db.query(User).filter(User.email == data.email).first()

    if not user or not verify_password(data.password, user.password_hash):
        raise HTTPException(401, "Sai tài khoản")

    token = create_token({"sub": user.email, "role": user.role})
    return {"access_token": token}

oauth2_scheme = OAuth2PasswordBearer(tokenUrl="auth/login")

@router.get("/me")
def get_current_user(token: str = Depends(oauth2_scheme), db: Session = Depends(get_db)):
    payload = decode_token(token)
    if not payload:
        raise HTTPException(
            status_code=status.HTTP_401_UNAUTHORIZED,
            detail="Token không hợp lệ hoặc đã hết hạn",
            headers={"WWW-Authenticate": "Bearer"},
        )

    email: str = payload.get("sub")
    if email is None:
        raise HTTPException(
            status_code=status.HTTP_401_UNAUTHORIZED,
            detail="Token thiếu thông tin người dùng",
        )

    user = db.query(User).filter(User.email == email).first()
    if user is None:
        raise HTTPException(status_code=404, detail="Không tìm thấy người dùng")

    return {
        "id": str(user.id),
        "email": user.email,
        "full_name": user.full_name,
        "avatar_url": user.avatar_url, # THÊM DÒNG NÀY
        "role": user.role if hasattr(user, 'role') else "user"
    }





@router.put("/update-profile")
async def update_profile(
    full_name: str = Form(None),          # Nhận tên
    avatar: UploadFile = File(None),      # Nhận file ảnh thật (Đã tách riêng)
    token: str = Depends(oauth2_scheme), 
    db: Session = Depends(get_db)
):
    payload = decode_token(token)
    email = payload.get("sub")
    user = db.query(User).filter(User.email == email).first()
    
    if not user:
        raise HTTPException(status_code=404, detail="User not found")

    # 1. Cập nhật tên (Chạy độc lập)
    if full_name:
        user.full_name = full_name

    # 2. Cập nhật ảnh (Chạy độc lập - Đã đưa ra ngoài)
    if avatar:
        # Tạo thư mục nếu chưa có
        os.makedirs("static/avatar", exist_ok=True)
        
        # Lưu file vật lý xuống ổ cứng
        file_location = f"static/avatar/{avatar.filename}"
        with open(file_location, "wb") as buffer:
            shutil.copyfileobj(avatar.file, buffer)
            
        # Lưu vào DB: Phải khớp với thư mục 'avatar'
        user.avatar_url = f"avatar/{avatar.filename}"
        
    db.commit()
    db.refresh(user)
    return {
        "message": "Update thành công", 
        "user": {
            "full_name": user.full_name, 
            "avatar_url": user.avatar_url
        }
    }