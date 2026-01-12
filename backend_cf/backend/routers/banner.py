from fastapi import APIRouter, Depends
from sqlalchemy.orm import Session
from database import get_db
from models.banner import Banner
from schemas.banner import BannerCreate, BannerOut
from typing import List

router = APIRouter(prefix="/banners", tags=["Banners"])

@router.get("/", response_model=List[BannerOut])
def get_banners(db: Session = Depends(get_db)):
    return db.query(Banner).order_by(Banner.sort_order).all()

@router.post("/", response_model=BannerOut)
def create_banner(banner: BannerCreate, db: Session = Depends(get_db)):
    new_banner = Banner(**banner.dict())
    db.add(new_banner)
    db.commit()
    db.refresh(new_banner)
    return new_banner
