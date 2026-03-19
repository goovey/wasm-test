#include <QApplication>
#include <QPushButton>

int main(int argc, char *argv[]) {
    QApplication app(argc, argv);

    QPushButton button("Hello WebAssembly! Click Me.");
    button.resize(300, 100);
    button.show();

    QObject::connect(&button, &QPushButton::clicked, [&]() {
        button.setText("It Works! Qt is running in your browser.");
    });

    return app.exec();
}
