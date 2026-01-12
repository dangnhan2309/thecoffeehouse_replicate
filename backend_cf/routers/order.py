from fastapi import APIRouter, Depends
from sqlalchemy.orm import Session
from database import get_db
from models.order import Order
from models.order_detail import OrderDetail
from schemas.order import OrderCreate, OrderResponse
from core.auth import get_current_user

router = APIRouter(prefix="/orders")

@router.post("/", response_model=OrderResponse)
def create_order(
    data: OrderCreate,
    user=Depends(get_current_user),
    db: Session = Depends(get_db)
):
    total_price = sum(item.quantity * item.price for item in data.items)

    order = Order(
        user_id=user["id"],  # nếu bạn trả payload có id
        total_price=total_price
    )
    db.add(order)
    db.commit()
    db.refresh(order)

    for item in data.items:
        detail = OrderDetail(
            order_id=order.id,
            product_id=item.product_id,
            quantity=item.quantity,
            price=item.price
        )
        db.add(detail)

    db.commit()
    db.refresh(order)

    return order

@router.get("/", response_model=list[OrderResponse])
def get_my_orders(
    user=Depends(get_current_user),
    db: Session = Depends(get_db)
):
    return db.query(Order).filter(Order.user_id == user["id"]).all()