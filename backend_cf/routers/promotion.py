from fastapi import APIRouter, Depends, HTTPException
from sqlalchemy.orm import Session, joinedload
from typing import List

from database import get_db
from models.promotion import Promotion
from models.promotion_product import PromotionProduct
from models.product import Product

from schemas.promotion import PromotionOut
from schemas.product import ProductOut

router = APIRouter(
    prefix="/promotions",
    tags=["Promotions"]
)
@router.get("/", response_model=List[PromotionOut])
def get_promotions(db: Session = Depends(get_db)):
    promotions = (
        db.query(Promotion)
        .filter(Promotion.is_active == True)
        .options(
            joinedload(Promotion.promotion_products)
            .joinedload(PromotionProduct.product)
        )
        .all()
    )
    return promotions
# @router.get("/{promotion_id}/products", response_model=List[int])
# def get_product_ids_by_promotion(promotion_id: int, db: Session = Depends(get_db)):
#     exists = db.query(Promotion).filter(Promotion.id == promotion_id).first()
#     if not exists:
#         raise HTTPException(status_code=404, detail="Promotion not found")

#     product_ids = (
#         db.query(PromotionProduct.product_id)
#         .filter(PromotionProduct.promotion_id == promotion_id)
#         .all()
#     )

#     return [pid[0] for pid in product_ids]
@router.get("/{promotion_id}/products/full", response_model=List[ProductOut])
def get_products_by_promotion(promotion_id: int, db: Session = Depends(get_db)):
    products = (
        db.query(Product)
        .join(PromotionProduct, Product.id == PromotionProduct.product_id)
        .filter(PromotionProduct.promotion_id == promotion_id)
        .all()
    )
    return products
