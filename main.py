#!/usr/bin/env python3

import sys
import os
from PyQt5.QtGui import QGuiApplication
from PyQt5.QtQml import QQmlApplicationEngine
from PyQt5.QtCore import QUrl, QFileSystemWatcher, QTimer
from MessageHandler import *
from PyQt5.QtQml import qmlRegisterSingletonType,qmlRegisterType

from ui.NetworkManager.Backend import *

# Try to import QQuickStyle, fallback if not available
try:
    from PyQt5.QtQuickControls2 import QQuickStyle
    HAS_QUICK_STYLE = True
except ImportError:
    HAS_QUICK_STYLE = False

class QMLLivePreview:
    """Live preview with auto-reload when files change"""
    
    def __init__(self):
        QGuiApplication.setAttribute(5, True)
        
        self.app = QGuiApplication(sys.argv)
        self.engine = QQmlApplicationEngine()
        self.file_watcher = QFileSystemWatcher()
        self.current_file = None
        
        self.file_watcher.fileChanged.connect(self.reload_file)
        
        self.reload_timer = QTimer()
        self.reload_timer.timeout.connect(self.perform_reload)
        self.reload_timer.setSingleShot(True)

        register_qml_types()

        qmlRegisterType(NetworkMonitor, "NetworkMonitor", 1, 0, "NetworkMonitor")


        ui_location = os.path.abspath("ui")
        self.engine.addImportPath(ui_location)
        
        print("Import paths:", self.engine.importPathList())

        if HAS_QUICK_STYLE:
            QQuickStyle.setStyle("Material")

    def load_qml_file(self, qml_file):
        """Load and watch a QML file"""
        if not os.path.exists(qml_file):
            print(f"Error: File {qml_file} not found!")
            return False
        
        self.current_file = os.path.abspath(qml_file)
        
        if self.current_file not in self.file_watcher.files():
            self.file_watcher.addPath(self.current_file)
        
        directory = os.path.dirname(self.current_file)
        if directory not in self.file_watcher.directories():
            self.file_watcher.addPath(directory)
        
        
        return self.reload_qml()
    
    def reload_qml(self):
        """Reload the current QML file"""
        if not self.current_file:
            return False
        
        print(f"Loading: {os.path.basename(self.current_file)}")
        
        self.engine.clearComponentCache()
        self.engine.load(QUrl.fromLocalFile(self.current_file))
        
        if not self.engine.rootObjects():
            print(f"Error: Failed to load {self.current_file}")
            return False
        
        print(f"✓ Successfully loaded {os.path.basename(self.current_file)}")
        return True
    
    def reload_file(self, file_path):
        """Handle file change event"""
        print(f"File changed: {os.path.basename(file_path)}")
        
        if file_path not in self.file_watcher.files():
            self.file_watcher.addPath(file_path)
        
        self.reload_timer.start(500)
    
    def perform_reload(self):
        """Actually perform the reload after debounce"""
        print("Reloading...")
        self.reload_qml()
    
    def run(self):
        """Run the live preview"""
        return self.app.exec_()

if __name__ == "__main__":
    if len(sys.argv) < 2:
        print("Usage: python QMLLivePreview.py <qml_file>")
        sys.exit(1)
    
    qml_file = sys.argv[1]
    
    preview = QMLLivePreview()
    
    if preview.load_qml_file(qml_file):
        print(f"Live preview started for {qml_file}")
        print("Edit the file - changes will auto-reload!")
        sys.exit(preview.run())
    else:
        print(f"Failed to load {qml_file}")
        sys.exit(1)