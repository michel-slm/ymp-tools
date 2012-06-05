from distutils.core import setup

setup(name='ymp-tools',
      version='0.1.0',
      description='Support for YMP one-click install files',
      author='Michel Alexandre Salim',
      author_email='michel@sylvestre.me',
      license='MIT',
      url='http://github.com/hircus/ymp-tools',
      packages=['ymp'],
      scripts=['scripts/ympcli'],
      )
