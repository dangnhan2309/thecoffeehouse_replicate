from sqlalchemy.orm import relationship
from database import Base
from sqlalchemy import Column, Integer, Float, String, Text, ForeignKey

class OrderDetail(Base):
    __tablename__ = "order_details"
    id = Column(Integer, primary_key=True, index=True)
    order_id = Column(Integer, ForeignKey("orders.id"))
    product_id = Column(Integer, ForeignKey("products.id"))
    quantity = Column(Integer)
    price = Column(Float)
    size = Column(String(50), nullable=True)
    ice = Column(String(50), nullable=True)
    sugar = Column(String(50), nullable=True)
    toppings = Column(Text, nullable=True)
    note = Column(Text, nullable=True)

    order = relationship("Order", back_populates="details")
    product = relationship("Product")