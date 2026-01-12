from fastapi import APIRouter, Depends
from sqlalchemy.orm import Session
from database import get_db
from models.collection import Collection
from schemas.collection import CollectionCreate, CollectionOut
from typing import List

router = APIRouter(prefix="/collections", tags=["Collections"])

@router.get("/", response_model=List[CollectionOut])
def get_collections(db: Session = Depends(get_db)):
    return db.query(Collection).filter(Collection.is_active == True).all()

@router.post("/", response_model=CollectionOut)
def create_collection(data: CollectionCreate, db: Session = Depends(get_db)):
    item = Collection(**data.dict())
    db.add(item)
    db.commit()
    db.refresh(item)
    return item
