from fastapi import APIRouter, Depends, HTTPException
from sqlalchemy.orm import Session, joinedload
from database import get_db
from models.order import Order
from models.order_detail import OrderDetail
from models.user import User
from schemas.order import OrderResponse, OrderItemCreate, CartItemUpdate
from core.auth import get_current_user
import json

router = APIRouter(prefix="/orders", tags=["Orders"])
@router.get("/history", response_model=list[OrderResponse])
def get_order_history(
    user: User = Depends(get_current_user),
    db: Session = Depends(get_db)
):
    orders = (
        db.query(Order)
        .options(joinedload(Order.details).joinedload(OrderDetail.product))
        .filter(
            Order.user_id == user.id,
            Order.status == "completed"
        )
        .order_by(Order.created_at.desc())
        .all()
    )

    result = []
    for order in orders:
        total_price = sum(d.price * d.quantity for d in order.details)

        result.append({
            "id": order.id,
            "user_id": order.user_id,
            "status": order.status,
            "total_price": total_price,
            "created_at": order.created_at,
            "items": [
                {
                    "id": d.id,
                    "product_id": d.product_id,
                    "product_name": d.product.name,
                    "product_image": d.product.image_url,
                    "quantity": d.quantity,
                    "price": d.price,
                    "size": d.size,
                    "ice": d.ice,
                    "sugar": d.sugar,
                    "toppings": json.loads(d.toppings) if d.toppings else [],
                    "note": d.note,
                }
                for d in order.details
            ],
        })

    return result

# =========================
# Helper: Get or create cart
# =========================
def get_or_create_cart(user_id: int, db: Session):
    cart = (
        db.query(Order)
        .filter(Order.user_id == user_id, Order.status == "pending")
        .first()
    )
    if not cart:
        cart = Order(user_id=user_id, status="pending")
        db.add(cart)
        db.commit()
        db.refresh(cart)
    return cart


# =========================
# GET CART
# =========================
@router.get("/cart", response_model=OrderResponse)
def get_cart(
    user: User = Depends(get_current_user),
    db: Session = Depends(get_db)
):
    cart = (
        db.query(Order)
        .options(joinedload(Order.details).joinedload(OrderDetail.product))
        .filter(Order.user_id == user.id, Order.status == "pending")
        .first()
    )

    if not cart:
        cart = get_or_create_cart(user.id, db)

    total_price = sum(d.price * d.quantity for d in cart.details)

    return {
        "id": cart.id,
        "user_id": cart.user_id,
        "status": cart.status,
        "total_price": total_price,
        "created_at": cart.created_at,
        "items": [
            {
                "id": d.id,
                "product_id": d.product_id,
                "product_name": d.product.name,
                "product_image": d.product.image_url,
                "quantity": d.quantity,
                "price": d.price,
                "size": d.size,
                "ice": d.ice,
                "sugar": d.sugar,
                "toppings": json.loads(d.toppings) if d.toppings else [],
                "note": d.note,
            }
            for d in cart.details
        ],
    }


# =========================
# ADD TO CART
# =========================
@router.post("/cart")
def add_to_cart(
    item: OrderItemCreate,
    user: User = Depends(get_current_user),
    db: Session = Depends(get_db),
):
    cart = get_or_create_cart(user.id, db)

    new_item = OrderDetail(
        order_id=cart.id,
        product_id=item.product_id,
        quantity=item.quantity,
        price=item.price,
        size=item.size,
        ice=item.ice,
        sugar=item.sugar,
        toppings=json.dumps(item.toppings) if item.toppings else "[]",
        note=item.note,
    )

    db.add(new_item)
    db.commit()

    return {"message": "Added to cart successfully"}


# =========================
# UPDATE CART ITEM
# =========================
@router.put("/cart/{product_id}")
def update_cart_item(
    product_id: int,
    data: CartItemUpdate,
    user: User = Depends(get_current_user),
    db: Session = Depends(get_db),
):
    cart = get_or_create_cart(user.id, db)

    item = (
        db.query(OrderDetail)
        .filter(
            OrderDetail.order_id == cart.id,
            OrderDetail.product_id == product_id,
        )
        .first()
    )

    if not item:
        raise HTTPException(status_code=404, detail="Item not found")

    if data.quantity is not None:
        item.quantity = data.quantity
    if data.size is not None:
        item.size = data.size
    if data.ice is not None:
        item.ice = data.ice
    if data.sugar is not None:
        item.sugar = data.sugar
    if data.note is not None:
        item.note = data.note
    if data.toppings is not None:
        item.toppings = json.dumps(data.toppings)

    db.commit()
    return {"message": "Cart item updated"}


# =========================
# REMOVE FROM CART
# =========================
@router.delete("/cart/{product_id}")
def remove_from_cart(
    product_id: int,
    user: User = Depends(get_current_user),
    db: Session = Depends(get_db),
):
    cart = get_or_create_cart(user.id, db)

    deleted = (
        db.query(OrderDetail)
        .filter(
            OrderDetail.order_id == cart.id,
            OrderDetail.product_id == product_id,
        )
        .delete()
    )

    if not deleted:
        raise HTTPException(status_code=404, detail="Item not found")

    db.commit()
    return {"message": "Item removed from cart"}


# =========================
# CHECKOUT (CASH)
# =========================
@router.post("/checkout/cash", response_model=OrderResponse)
def checkout_cash(
    user: User = Depends(get_current_user),
    db: Session = Depends(get_db),
):
    cart = get_or_create_cart(user.id, db)

    cart.status = "completed"
    db.commit()
    db.refresh(cart)

    total_price = sum(d.price * d.quantity for d in cart.details)

    return {
        "id": cart.id,
        "user_id": cart.user_id,
        "status": cart.status,
        "total_price": total_price,
        "created_at": cart.created_at,
        "items": []
    }
