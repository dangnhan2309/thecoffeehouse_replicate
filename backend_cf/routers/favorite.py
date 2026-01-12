from fastapi import APIRouter, Depends, HTTPException
from sqlalchemy.orm import Session
from database import get_db
from models.favorite import Favorite
from models.user import User
from core.auth import get_current_user

router = APIRouter(prefix="/favorites", tags=["Favorites"])


# =========================
# TOGGLE FAVORITE
# =========================
@router.post("/toggle/{product_id}")
def toggle_favorite(
    product_id: int,
    user: User = Depends(get_current_user),
    db: Session = Depends(get_db)
):
    fav = (
        db.query(Favorite)
        .filter(
            Favorite.user_id == user.id,
            Favorite.product_id == product_id
        )
        .first()
    )

    if fav:
        db.delete(fav)
        db.commit()
        return {"is_favorite": False}

    new_fav = Favorite(user_id=user.id, product_id=product_id)
    db.add(new_fav)
    db.commit()
    return {"is_favorite": True}


# =========================
# GET FAVORITES
# =========================
@router.get("")
def get_favorites(
    user: User = Depends(get_current_user),
    db: Session = Depends(get_db)
):
    favorites = (
        db.query(Favorite)
        .filter(Favorite.user_id == user.id)
        .all()
    )
    return favorites
