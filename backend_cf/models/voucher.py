from sqlalchemy import Column, Integer, String, Float, DateTime, Boolean
from datetime import datetime
from database import Base

class Voucher(Base):
    __tablename__ = "vouchers"

    id = Column(Integer, primary_key=True, index=True)
    code = Column(String(50), unique=True, index=True)  # ✅ FIX
    title = Column(String(255))
    description = Column(String(500), nullable=True)
    discount_amount = Column(Float)
    min_order_value = Column(Float, default=0)
    start_date = Column(DateTime, default=datetime.utcnow)
    expiry_date = Column(DateTime)
    is_active = Column(Boolean, default=True)
