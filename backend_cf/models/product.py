from sqlalchemy import Column, Integer, String, Float, ForeignKey
from sqlalchemy.orm import relationship
from database import Base

class Product(Base):
    __tablename__ = "products"

    id = Column(Integer, primary_key=True, index=True)
    name = Column(String(255), index=True)
    description = Column(String(255))

    price = Column(Float, nullable=True)
    price_small = Column(Float, nullable=True)
    price_medium = Column(Float, nullable=True)
    price_large = Column(Float, nullable=True)

    image_url = Column(String(255))
    category_id = Column(Integer, ForeignKey("categories.id"))

    category = relationship("Category", back_populates="products")
    favorites = relationship("Favorite", back_populates="product")

    # ✅ THÊM DÒNG NÀY
    promotion_products = relationship(
        "PromotionProduct",
        back_populates="product"
    )
