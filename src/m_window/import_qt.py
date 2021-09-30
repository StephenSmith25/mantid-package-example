from importlib import import_module

def import_qt(modulename, package, attr=None):
    if modulename.startswith('.'):
        try:
            lib = import_module(modulename, package)
        except ImportError as e1:
            try:
                lib = import_module(modulename.lstrip('.'))
            except ImportError as e2:
                msg = 'import of "{}" failed with "{}"'
                msg = 'First ' + msg.format(modulename, e1) \
                      + '. Second ' + msg.format(modulename.lstrip('.'), e2)
                raise ImportError(msg)
    else:
        lib = import_module(modulename)

    if attr is not None:
        return getattr(lib, attr)
    else:
        return lib