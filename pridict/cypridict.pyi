from typing import Any, ClassVar, Optional

class priority_dict:
    __pyx_vtable__: ClassVar[PyCapsule] = ...
    def __init__(self, priorities: Optional[dict] = None) -> None: ...
    def heap_size(self) -> int: ...
    def peek(self) -> int: ...
    def peekval(self) -> float: ...
    def pop(self) -> int: ...
    def __iter__(self) -> Any: ...
    def __len__(self) -> int: ...
    def __setitem__(self, key: int, val: float) -> None: ...