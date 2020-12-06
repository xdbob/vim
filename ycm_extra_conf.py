# TODO: look inside /tmp
import logging
import os.path
import shutil

logger = logging.getLogger('extra_config')

BASE_FLAGS = [
    '-Wall',
    '-Wextra',
    '-Werror',
    '-Wno-long-long',
    '-Wno-variadic-macros',
    '-DNDEBUG',
]

C_FLAGS = [
    '-x',
    'c',
    '-std=c99',
]

CXX_FLAGS = [
    '-x',
    'c++',
    '-std=c++17',
]

C_SOURCE_EXT = [
    '.c',
]

CXX_SOURCE_EXT = [
    '.cpp',
    '.cxx',
    '.cc',
    '.m',
    '.mm',
]

C_HEADER_EXT = [
    '.h',
]

CXX_HEADER_EXT = [
    '.hh',
    '.hxx',
    '.hpp',
]

BUILD_DIRS = [
    'build',
    'builddir',
]

def is_source_file(filename):
    return os.path.splitext(filename)[1] in C_SOURCE_EXT + CXX_SOURCE_EXT


def is_header_file(filename):
    return os.path.splitext(filename)[1] in C_HEADER_EXT + CXX_HEADER_EXT


def is_cxx_file(filename):
    return os.path.splitext(filename)[1] in CXX_SOURCE_EXT + CXX_HEADER_EXT


def find_source_from_file(filename):
    if is_header_file(filename):
        basename = os.path.splitext(filename)[0]
        for extension in C_SOURCE_EXT + CXX_SOURCE_EXT:
            source = basename + extension
            if os.path.exists(source):
                return source
    return filename

def make_cflags_absolute(flags, working_dir):
    if not working_dir:
        return list(flags)
    new_flags = []
    make_next_absolute = False
    path_flags = [ '-isystem', '-I', '-iquote', '--sysroot=' ]
    for flag in flags:
        f = flag
        if make_next_absolute:
            make_next_absolute = False
            if not flag.startswith('/'):
                f = os.path.join(working_dir, flag)
        else:
            for path_flag in path_flags:
                if path_flag == flag:
                    make_next_absolute = True
                    break
                if flag.startswith(path_flag):
                    f = path_flag + os.path.join(working_dir, flag[len(path_flag):])
                    break
        new_flags.append(f)
    return new_flags

def find_nearest(path, target, builddirs=None, maxdepth=os.path.expanduser('~')):
    def _find_nearest(path, target, builddirs, maxdepth):
        candidate = os.path.join(path, target)
        if os.path.exists(candidate):
            logger.info(f'Found {target} at {candidate}')
            return candidate
        if builddirs is not None:
            for build in builddirs:
                candidate = os.path.join(path, build, target)
                if os.path.exists(candidate):
                    logger.info(f'Found {target} in builddir {os.path.join(path, build)}')
                    return candidate
        parent = os.path.dirname(os.path.abspath(path))
        if parent == maxdepth:
            return None
        return _find_nearest(parent, target, builddirs, maxdepth)
    maxdepth = os.path.abspath(maxdepth)
    if not os.path.abspath(path).startswith(maxdepth):
        # Let's explore path and only path
        return _find_nearest(path, target, builddirs, os.path.dirname(path))
    return _find_nearest(path, target, builddirs, os.path.dirname(maxdepth))

database = None
def load_db(root, filename):
    global database
    import ycm_core
    database_path = find_nearest(root, 'compile_commands.json', BUILD_DIRS)
    if not database_path:
        logger.info('no compile_commands.json found')
        return None
    database_dir = os.path.dirname(database_path)
    logger.info(f'Compilation database found at {database_dir}')
    database = ycm_core.CompilationDatabase(database_dir)
    if not database:
        logger.warn('Unable to load compilation database')
        return None
    compilation_infos = database.GetCompilationInfoForFile(filename)
    if not compilation_infos:
        logger.warn(f'No compilation info for {filename} in compilation database')
        return None
    return make_cflags_absolute(compilation_infos.compiler_flags_,
                                compilation_infos.compiler_working_dir_)


def Settings(filename, language, **kwargs):
    root = os.path.realpath(filename)
    logger.info(f'extra config loading: {filename}')

    if language == 'cfamily':
        filename = find_source_from_file(filename)
        logger.debug(f'matching source file: {filename}')
        flags = load_db(root, filename)
        if not flags:
            if is_source_file(filename):
                if is_cxx_file(filename):
                    flags = BASE_FLAGS + CXX_FLAGS
                else:
                    flags = BASE_FLAGS + C_FLAGS
        return {'flags': flags}
    if language == 'python':
        # TODO: venv project config file
        python = find_nearest(root, 'bin/python', ['env', 'venv', '.venv'])
        logger.info(f'venv: {python}')
        if python is None:
            python = shutil.which('python3')
        return {'interpreter_path': python}
    return {}
