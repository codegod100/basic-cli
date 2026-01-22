import InternalPath
import Host

Path := InternalPath.UnwrappedPath

from_str : Str -> Path
from_str = |str|
    InternalPath.FromStr(str)
