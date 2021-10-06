from qtpy.QtWidgets import QMainWindow, QApplication, QVBoxLayout, QPushButton, QMessageBox, QWidget

# Ensure that all expected packages are present

# import qt from C++
from .import_qt import import_qt

MessageBox = import_qt('._message_box', 'm_window', 'MessageBox')
USE_KERNEL = 'python3'

from qtconsole.rich_jupyter_widget import RichJupyterWidget
from qtconsole.manager import QtKernelManager

def make_jupyter_widget_with_kernel():
    """Start a kernel, connect to it, and create a RichJupyterWidget to use it
    """
    kernel_manager = QtKernelManager(kernel_name=USE_KERNEL)
    kernel_manager.start_kernel()

    kernel_client = kernel_manager.client()
    kernel_client.start_channels()

    jupyter_widget = RichJupyterWidget()
    jupyter_widget.kernel_manager = kernel_manager
    jupyter_widget.kernel_client = kernel_client
    return jupyter_widget

class MainWindow(QMainWindow):
    def __init__(self):
        super().__init__()
        self.layout = QVBoxLayout()
        self.main_widget = QWidget()
        self.python_button = QPushButton("Python Button")
        self.cpp_button = QPushButton("C++ Button")
        self.jupyter_widget = make_jupyter_widget_with_kernel()
        self.layout.addWidget(self.python_button)
        self.layout.addWidget(self.cpp_button)
        self.layout.addWidget(self.jupyter_widget)
        self.main_widget.setLayout(self.layout)

        self.setCentralWidget(self.main_widget)

        self.python_button.clicked.connect(self.display_message)
        self.cpp_button.clicked.connect(self.display_cpp_message)

    def display_message(self):
        QMessageBox.information(self, 'PyQt5 message', "This is from python!")

    def display_cpp_message(self):
        cpp_msg = "This is from C++"
        msgbox = MessageBox(self, "Qt5 message", cpp_msg)


def main():
    app = QApplication([])
    main_window = MainWindow()
    main_window.show()
    app.exec_()


if __name__ == '__main__':
    main()