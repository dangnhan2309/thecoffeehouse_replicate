from fastapi import APIRouter, Depends
from sqlalchemy.orm import Session
from database import get_db
from models.favorite import Favorite
from core.auth import get_current_user 

router = APIRouter(prefix="/favorites", tags=["Favorites"])
@router.post("/favorites/{product_id}")
def add_favorite(product_id: int, user=Depends(get_current_user), db: Session = Depends(get_db)):
    fav = Favorite(user_id=user.id, product_id=product_id)
    db.add(fav)
    db.commit()
    return {"message": "Added to favorite"}
