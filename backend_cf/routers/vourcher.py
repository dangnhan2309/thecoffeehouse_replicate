from fastapi import APIRouter, Depends, HTTPException
from sqlalchemy.orm import Session
from typing import List
import models.voucher as models
import schemas.vourcher as schemas
from database import get_db

router = APIRouter(prefix="/vouchers", tags=["Vouchers"])

@router.get("/", response_model=List[schemas.VoucherRead])
def get_vouchers(db: Session = Depends(get_db)):
    return db.query(models.Voucher).filter(models.Voucher.is_active == True).all()

@router.post("/", response_model=schemas.VoucherRead)
def create_voucher(voucher: schemas.VoucherBase, db: Session = Depends(get_db)):
    db_voucher = models.Voucher(**voucher.model_dump())
    db.add(db_voucher)
    db.commit()
    db.refresh(db_voucher)
    return db_voucher