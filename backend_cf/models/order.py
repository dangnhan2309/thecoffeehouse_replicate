from sqlalchemy import Column, Integer, String, DateTime, ForeignKey
from sqlalchemy.orm import relationship
from datetime import datetime
from database import Base

class Order(Base):
    __tablename__ = "orders"

    id = Column(Integer, primary_key=True)
    user_id = Column(Integer, ForeignKey("users.id"))
    status = Column(String(50), default="cart")
    created_at = Column(DateTime, default=datetime.now)

    details = relationship("OrderDetail", back_populates="order", cascade="all, delete")
    user = relationship("User", back_populates="orders")