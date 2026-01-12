from fastapi import APIRouter, Depends
from sqlalchemy.orm import Session
from database import get_db
from models.category import Category
from schemas.category import CategoryCreate

router = APIRouter(prefix="/categories", tags=["Categories"])

# GET tất cả category
@router.get("/")
def get_categories(db: Session = Depends(get_db)):
    return db.query(Category).all()

# POST tạo category
@router.post("/")
def create_category(category: CategoryCreate, db: Session = Depends(get_db)):
    c = Category(**category.dict())
    db.add(c)
    db.commit()
    db.refresh(c)
    return c
