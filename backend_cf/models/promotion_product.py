from sqlalchemy import Column, Integer, ForeignKey
from sqlalchemy.orm import relationship
from database import Base

class PromotionProduct(Base):
    __tablename__ = "promotion_products"

    promotion_id = Column(
        Integer,
        ForeignKey("promotions.id"),
        primary_key=True
    )
    product_id = Column(
        Integer,
        ForeignKey("products.id"),
        primary_key=True
    )

    # ✅ BẮT BUỘC PHẢI CÓ
    promotion = relationship(
        "Promotion",
        back_populates="promotion_products"
    )

    product = relationship(
        "Product",
        back_populates="promotion_products"
    )
