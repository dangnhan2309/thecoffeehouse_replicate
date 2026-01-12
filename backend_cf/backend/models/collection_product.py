from sqlalchemy import Column, Integer, ForeignKey
from database import Base

class CollectionProduct(Base):
    __tablename__ = "collection_products"

    collection_id = Column(
        Integer,
        ForeignKey("collections.id"),
        primary_key=True
    )
    product_id = Column(
        Integer,
        ForeignKey("products.id"),
        primary_key=True
    )
    sort_order = Column(Integer, default=0)
