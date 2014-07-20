from distutils.core import setup
from distutils.extension import Extension
import Cython.Compiler.Options
#Cython.Compiler.Options.annotate = True
from Cython.Distutils import build_ext
import os
from os.path import join, sep, dirname, basename, abspath
import pys2talk


includes = []
if 'PYS2TALK_INCLUDE' in os.environ:
    includes.insert(0, os.environ['PYS2TALK_INCLUDE'])


sources = ['talker.pyx',
           'timer.pyx',
           'exception.pyx',
           ]

dependencies = {'talker.pyx': ['talker.pxd', 'exception.pyx'],
                'timer.pyx': ['timer.pxd'],
                'exception.pyx': []
                }


def get_modulename_from_file(filename):
    filename = filename.replace(sep, '/')
    pyx = '.'.join(filename.split('.')[:-1])
    pyxl = pyx.split('/')
    while pyxl[0] != 'pys2talk':
        pyxl.pop(0)
    if pyxl[1] == 'pys2talk':
        pyxl.pop(0)
    return '.'.join(pyxl)


def expand(*args):
    return abspath(join(dirname(__file__), 'pys2talk', *args))


def get_dependencies(name, deps=None):
    if deps is None:
        deps = []
    for dep in dependencies.get(name, []):
        if dep not in deps:
            deps.append(dep)
            get_dependencies(dep, deps)
    return deps


def resolve_dependencies(fn):
    deps = []
    get_dependencies(fn, deps)
    get_dependencies(fn.replace('.pyx', '.pxd'), deps)
    return [expand(x) for x in deps]


def get_extensions_from_sources(sources):
    ext_modules = []
    for pyx in sources:
        depends = resolve_dependencies(pyx)
        pyx = expand(pyx)
        module_name = get_modulename_from_file(pyx)
        ext_modules.append(Extension(module_name, [pyx], depends=depends,
                                     include_dirs=includes, language="c++"))
    return ext_modules

ext_modules = get_extensions_from_sources(sources)

for e in ext_modules:
    e.cython_directives = {'embedsignature': True,
                           'c_string_encoding': 'utf-8'}

setup(
    name='PyS2Talk',
    version=pys2talk.__version__,
    author='Matthew Einhorn',
    author_email='moiein2000@gmail.com',
    license='MIT',
    description=(
        'A python implementation of the Spike2 Talker.'),
    ext_modules=ext_modules,
    cmdclass={'build_ext': build_ext},
    packages=['pys2talk']
      )
