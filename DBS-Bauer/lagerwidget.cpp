#include "lagerwidget.h"
#include "ui_lagerwidget.h"
#include "insertlagerdialog.h"
#include <QtSql/QSqlDatabase>
#include <QDebug>
#include <QSqlError>
#include <QSqlQuery>
#include <QSqlQueryModel>
#include <QMessageBox>
#include "errordialog.h"

LagerWidget::LagerWidget(QWidget *parent) :
	QWidget(parent),
	ui(new Ui::LagerWidget)
{
	ui->setupUi(this);
	futter = new QSqlQueryModel(ui->tableFutterbestand);
	maschine = new QSqlQueryModel(ui->tableLagerMaschine);
	saat = new QSqlQueryModel(ui->tableSaatgutbestand);
	duenger = new QSqlQueryModel(ui->tableDungerbestand);
	lager = new QSqlTableModel(ui->tableLager);
	lager->setTable("lager");
	lager->setEditStrategy(QSqlTableModel::OnFieldChange);

	if(!lager->select()) {
		ErrorDialog() << lager->lastError();
	}
	ui->tableLager->setModel(lager);
	ui->tableLager->setSelectionBehavior(QAbstractItemView::SelectRows);
	ui->tableLager->setSelectionMode(QAbstractItemView::SingleSelection);

	// PK verstecken
	ui->tableLager->hideColumn(0);
}

LagerWidget::~LagerWidget()
{
	delete lager;
	delete futter;
	delete maschine;
	delete saat;
	delete duenger;
	delete ui;
}

void LagerWidget::on_tableLager_clicked(const QModelIndex &index)
{
	bool ok = false;
	currentPk = (lager->index(index.row(), 0)).data().toInt(&ok);

	if (currentPk <= 0 || !ok) {
		ErrorDialog() << lager->lastError();
	} else {
		SetupSubTables(index);
	}
}

void LagerWidget::SetupSubTables(const QModelIndex &index)
{
	SetupDuenger(index);
	SetupFutter(index);
	SetupMaschinen(index);
	SetupSaat(index);
}

void LagerWidget::SetupDuenger(const QModelIndex &index)
{
	QSqlQuery q;
	if (!q.exec(QString("SELECT * FROM usp_DuengerBestand(%1);").arg(QString::number(currentPk)))) {
		ErrorDialog() << q.lastError();
	}
	duenger->setQuery(q);
	ui->tableDungerbestand->setModel(duenger);
	ui->tableDungerbestand->hideColumn(0);
}

void LagerWidget::SetupFutter(const QModelIndex &index)
{
	QSqlQuery q;
	if (!q.exec(QString("SELECT * FROM usp_FutterLagerBestand(%1);").arg(QString::number(currentPk)))) {
		ErrorDialog() << q.lastError();
	}
	futter->setQuery(q);
	ui->tableFutterbestand->setModel(futter);
	ui->tableFutterbestand->hideColumn(0);
}

void LagerWidget::SetupMaschinen(const QModelIndex &index)
{
	QSqlQuery q;
	if (!q.exec(QString("SELECT * FROM usp_LagerMaschine(%1);").arg(QString::number(currentPk)))) {
		ErrorDialog() << q.lastError();
	}
	maschine->setQuery(q);
	ui->tableLagerMaschine->setModel(maschine);
	ui->tableLagerMaschine->hideColumn(0);
}

void LagerWidget::SetupSaat(const QModelIndex &index)
{
	QSqlQuery q;
	if (!q.exec(QString("SELECT * FROM usp_SaatgutBestand(%1);").arg(QString::number(currentPk)))) {
		ErrorDialog() << q.lastError();
	}
	saat->setQuery(q);
	ui->tableSaatgutbestand->setModel(saat);
	ui->tableSaatgutbestand->hideColumn(0);
}

void LagerWidget::on_LagerEinfuegen_clicked()
{
	InsertLagerDialog d;
	d.setModal(true);
	d.exec();
	lager->select();
}

void LagerWidget::on_LagerTot_clicked()
{
	QSqlQuery q;
	if (!q.exec(QString("SELECT usp_DeleteLager(%1, 'f') ;").arg(QString::number(currentPk)))) {


		QMessageBox m;
		m.setText("Wenn sie fortfahren werden alle Einträge gelöscht die mit diesem Lager in verbindung stehen.");
		m.setStandardButtons(QMessageBox::Yes | QMessageBox::No);
		m.setIcon(QMessageBox::Warning);
		m.setDefaultButton(QMessageBox::No);
		int ret = m.exec();
		switch (ret) {
		case QMessageBox::Yes:

			if (!q.exec(QString("SELECT usp_DeleteLager(%1, 't') ;").arg(QString::number(currentPk)))) {
				ErrorDialog() << q.lastError(); //need more indent
			}
			break;
		default:
			break;
		}
	}
	lager->select();
}
