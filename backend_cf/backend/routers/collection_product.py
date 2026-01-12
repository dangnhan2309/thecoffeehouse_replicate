from fastapi import APIRouter, Depends
from sqlalchemy.orm import Session
from database import get_db
from models.collection_product import CollectionProduct
from schemas.collection_product import (
    CollectionProductCreate,
    CollectionProductOut
)
from typing import List

router = APIRouter(
    prefix="/collection-products",
    tags=["Collection Products"]
)

# 🔹 Lấy danh sách product theo collection
@router.get(
    "/collection/{collection_id}",
    response_model=List[CollectionProductOut]
)
def get_products_by_collection(
    collection_id: int,
    db: Session = Depends(get_db)
):
    return (
        db.query(CollectionProduct)
        .filter(CollectionProduct.collection_id == collection_id)
        .order_by(CollectionProduct.sort_order)
        .all()
    )

# 🔹 Gắn product vào collection
@router.post("/", response_model=CollectionProductOut)
def add_product_to_collection(
    data: CollectionProductCreate,
    db: Session = Depends(get_db)
):
    item = CollectionProduct(**data.dict())
    db.add(item)
    db.commit()
    return item