from sqlalchemy import Column, Integer, String, Float, Boolean, DateTime, Time
from datetime import datetime
from database import Base

class Store(Base):
    __tablename__ = "stores"

    id = Column(Integer, primary_key=True, index=True)
    code = Column(String(50), unique=True, nullable=False)

    name = Column(String(255), nullable=False)
    address = Column(String(500), nullable=False)

    city = Column(String(100), index=True)
    district = Column(String(100))

    latitude = Column(Float, index=True)
    longitude = Column(Float, index=True)

    open_time = Column(Time)
    close_time = Column(Time)

    phone = Column(String(20))
    image_url = Column(String(255))

    is_active = Column(Boolean, default=True, index=True)
    created_at = Column(DateTime, default=datetime.utcnow)
