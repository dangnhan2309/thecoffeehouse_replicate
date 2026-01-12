# routers/product.py
from fastapi import APIRouter, Depends
from sqlalchemy.orm import Session
from database import get_db
from models.product import Product as ProductModel
from schemas.product import ProductOut, ProductCreate, ProductIdRequest

router = APIRouter(prefix="/products", tags=["Products"])

@router.get("/", response_model=list[ProductOut])
def get_products(db: Session = Depends(get_db)):
    return db.query(ProductModel).all()  
@router.get("/category/{category_id}", response_model=list[ProductOut])
def get_by_category(category_id: int, db: Session = Depends(get_db)):
    return db.query(ProductModel).filter(ProductModel.category_id == category_id).all()

@router.post("/", response_model=ProductOut)
def create_product(product: ProductCreate, db: Session = Depends(get_db)):
    p = ProductModel(**product.dict()) 
    db.add(p)
    db.commit()
    db.refresh(p)
    return p

@router.post("/by-id", response_model=ProductOut)
def get_product_by_id(data: ProductIdRequest, db: Session = Depends(get_db)):
    product = db.query(ProductModel).filter(ProductModel.id == data.id).first()
    if not product:
        raise HTTPException(status_code=404, detail="Product not found")
    return product

# Lấy nhiều product theo list id
@router.post("/by-ids", response_model=list[ProductOut])
def get_products_by_ids(data: ProductIdRequest, db: Session = Depends(get_db)):
    return db.query(ProductModel).filter(ProductModel.id.in_(data.ids)).all()