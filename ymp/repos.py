from abc import ABCMeta, abstractmethod
from ConfigParser import ConfigParser
from cStringIO import StringIO
from yum import YumBase

class Repository(object):
    __metaclass__ = ABCMeta

    """
    Initializes a repository object from the
    dictionary of fields parsed from the
    ymp file
    """
    def __init__(self, d):
        self.__dict__.update(d)
        self.create_configuration()

    @abstractmethod
    def create_configuration(self):
        pass

    @abstractmethod
    def persist(self):
        pass

class YumRepository(Repository):

    def create_configuration(self):
        config = ConfigParser()
        config.add_section(self.name)
        "Set the repo summary - Yum calls it 'name'"
        config.set(self.name, 'name', self.summary)
        config.set(self.name, 'baseurl', self.url)
        config.set(self.name, 'enabled', 1 if self.recommended else 0)
    
        self.config = config

    def persist(self):
        y = YumBase()
        matches = y.repos.findRepos(self.name)
        # the repo name must be invalid if there are more than 1 matches
        assert len(matches) <= 1
        if len(matches) == 0:
            # repo not present yet
            target = '/etc/yum.repos.d/ymp-%s.repo' % (self.name,)
            print 'Persisting to %s' % (target,)
            with file(target, 'w') as f:
                f.write(self.__repr__())
        else:
            print ('repo %s already registered' % (self.name,))
            
    def __repr__(self):
        config_io = StringIO()
        self.config.write(config_io)
        return config_io.getvalue()
        
    
