from fastapi import APIRouter, Depends, Query
from sqlalchemy.orm import Session
from typing import List

from database import get_db
from models.store import Store
from schemas.store import StoreResponse
from schemas.city_enum import CityEnum

router = APIRouter(prefix="/stores", tags=["Stores"])


# ======================================================
# 1️⃣ Lấy tất cả cửa hàng (có phân trang) — FIX MSSQL
# ======================================================
@router.get("/", response_model=List[StoreResponse])
def get_stores(
    skip: int = Query(0, ge=0),
    limit: int = Query(20, ge=1, le=100),
    db: Session = Depends(get_db)
):
    stores = (
        db.query(Store)
        .filter(Store.is_active == True)
        .order_by(Store.id)          # ⭐ BẮT BUỘC cho MSSQL
        .offset(skip)
        .limit(limit)
        .all()
    )
    return stores


# ======================================================
# 2️⃣ Lấy cửa hàng theo thành phố
# ======================================================
@router.get("/by-city", response_model=List[StoreResponse])
def get_stores_by_city(
    city: CityEnum,
    db: Session = Depends(get_db)
):
    stores = (
        db.query(Store)
        .filter(
            Store.code.startswith(city.value),
            Store.is_active == True
        )
        .order_by(Store.id)
        .all()
    )

    print(f"DEBUG: Found {len(stores)} stores for city {city.value}")
    return stores


# ======================================================
# 3️⃣ Lấy cửa hàng gần nhất (distance đơn giản)
# ======================================================
@router.get("/nearest", response_model=List[StoreResponse])
def get_nearest_stores(
    lat: float = Query(...),
    lng: float = Query(...),
    limit: int = Query(5, ge=1, le=20),
    db: Session = Depends(get_db)
):
    stores = (
        db.query(Store)
        .filter(
            Store.is_active.is_(True),
            Store.latitude.isnot(None),
            Store.longitude.isnot(None)
        )
        .order_by(
            (Store.latitude - lat) * (Store.latitude - lat) +
            (Store.longitude - lng) * (Store.longitude - lng)
        )
        .limit(limit)
        .all()
    )

    return stores
