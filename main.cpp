#include <QApplication>
#include <QHeaderView>
#include <QMainWindow>
#include <QStringList>
#include <QTableWidget>

int main(int argc, char* argv[]) {
  QApplication app(argc, argv);

  QMainWindow window;
  window.setWindowTitle("Qt WebAssembly Table Demo");

  // Initialize Table Widget
  QTableWidget* table = new QTableWidget(5, 3, &window);
  table->setHorizontalHeaderLabels({"Process ID", "Service Name", "Status"});

  // Sample Data Population
  QStringList services = {"Systemd", "NetworkManager", "Docker", "Nginx",
                          "PostgreSQL"};
  QStringList statuses = {"Running", "Running", "Stopped", "Running", "Active"};

  for (int row = 0; row < 5; ++row) {
    table->setItem(row, 0, new QTableWidgetItem(QString::number(1000 + row)));
    table->setItem(row, 1, new QTableWidgetItem(services.at(row)));
    table->setItem(row, 2, new QTableWidgetItem(statuses.at(row)));
  }

  // UI Optimization for Web View
  table->horizontalHeader()->setSectionResizeMode(QHeaderView::Stretch);
  table->setAlternatingRowColors(true);

  window.setCentralWidget(table);
  window.resize(600, 400);
  window.show();

  return app.exec();
}
