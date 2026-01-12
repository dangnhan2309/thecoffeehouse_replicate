from sqlalchemy import Column, Integer, String, DateTime, Boolean, Text, DECIMAL
from sqlalchemy.sql import func
from sqlalchemy.orm import relationship
from database import Base

class Promotion(Base):
    __tablename__ = "promotions"

    id = Column(Integer, primary_key=True, index=True)
    name = Column(String(150), nullable=False)
    description = Column(Text)
    discount_percent = Column(Integer)
    discount_amount = Column(DECIMAL(10,2))
    start_date = Column(DateTime, nullable=False)
    end_date = Column(DateTime, nullable=False)
    is_active = Column(Boolean, default=True)
    created_at = Column(DateTime, server_default=func.now())

    # ✅ THÊM DÒNG NÀY
    promotion_products = relationship(
        "PromotionProduct",
        back_populates="promotion"
    )
