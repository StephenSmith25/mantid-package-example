#include <QString>
#include <QMessageBox>

class MessageBox {
public:
    MessageBox(QWidget *parent, QString &title, QString &cppMsg) {
        QMessageBox::information(parent, title, cppMsg);
    }
};