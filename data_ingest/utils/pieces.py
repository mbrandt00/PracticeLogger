from dataclasses import dataclass, field
from typing import List, Optional

from bs4 import Tag
from movements import Movement, parse_movements


@dataclass
class Work:
    id: str
    title: str
    opus: Optional[int] = None
    number: Optional[int] = None
    key_signature: Optional[str] = None
    movements: List[Movement] = field(default_factory=list)

def create_piece(data: Tag):
   movements = parse_movements(data)
   print(movements)
   print(data)
