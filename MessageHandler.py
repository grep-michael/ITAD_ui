from PyQt5.QtCore import QObject, pyqtSignal, pyqtSlot, pyqtProperty, QVariant
from PyQt5.QtQml import qmlRegisterSingletonType,qmlRegisterType


class UIMessage(QObject):
    def __init__(self, message_type="info", title="", content="", data=None, parent=None):
        super().__init__(parent)
        self._message_type = message_type
        self._title = title
        self._content = content
        self._data = data

    # Define properties that can be accessed from QML
    @pyqtProperty(str, constant=True)
    def messageType(self):
        return self._message_type
    
    @pyqtProperty(str, constant=True) 
    def title(self):
        return self._title
        
    @pyqtProperty(str, constant=True)
    def content(self):
        return self._content
        
    @pyqtProperty(QVariant, constant=True)
    def data(self):
        return self._data
    
    def __str__(self):
        return "{} : {} - {} | {}".format(self._message_type,self._title,self._content,self._data.toVariant())

class MessageManager(QObject):
    # Signal that emits UIMessage objects
    messageEmitted = pyqtSignal(UIMessage)


    def __init__(self, parent=None):
        super().__init__(parent)
        self._created_messages = []
    
    @pyqtSlot(str, str, str, QVariant, result=UIMessage)
    def createMessage(self, message_type, title, content, data=None):
        """Create a UIMessage from QML parameters"""
        message = UIMessage(message_type, title, content, data)
        self._created_messages.append(message)
        if len(self._created_messages) > 100:
            self._created_messages = self._created_messages[-50:]
        return message
    
    @pyqtSlot(UIMessage)
    def emitMessage(self, message):
        """Emit a UIMessage object"""
        print(message)
        self.messageEmitted.emit(message)
        
    @pyqtSlot(str, str, str, QVariant)
    def sendMessage(self, message_type, title, content, data=None):
        """Create and emit message in one call"""
        message = UIMessage(message_type, title, content, data)
        self.messageEmitted.emit(message)

# Singleton factory function
def message_manager_factory(qml_engine, js_engine):
    return MessageManager()

# Register singleton
def register_qml_types():
    qmlRegisterType(UIMessage, "CustomTypes", 1, 0, "UIMessage")
    
    qmlRegisterSingletonType(MessageManager, "MessageSystem", 1, 0, 
                           "MessageManager", message_manager_factory)