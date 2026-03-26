import sys
from pathlib import Path

import uvicorn


def main() -> None:
    project_root = Path(__file__).resolve().parent
    src_path = project_root / "src"

    if str(src_path) not in sys.path:
        sys.path.insert(0, str(src_path))

    uvicorn.run(
        "openbachelors.app:app",
        host="0.0.0.0",
        port=8443,
        reload=True,
    )

if __name__ == "__main__":
    main()
