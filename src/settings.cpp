#include "settings.h"

Settings::Settings(QObject *parent) :
    QObject(parent)
{
}

void Settings::setValue(const QString &key, const QVariant &value) {
    m_settings.setIniCodec( "UTF-8" );
    m_settings.setValue(key, value);
}
int Settings::valueInt(const QString& key, int defaultValue) const {
    return value(key, defaultValue).toInt();
}
QString Settings::valueString(const QString& key, const QString& defaultValue) const {
    return value(key, defaultValue).toString();
}
QVariant Settings::value(const QString &key, const QVariant &defaultValue) const {
    return m_settings.value(key, defaultValue);
}
bool Settings::contains(const QString &key) const {
    return m_settings.contains(key);
}
void Settings::remove(const QString& key) {
    m_settings.setIniCodec( "UTF-8" );
    return m_settings.remove(key);
}
void Settings::sync() {
    return m_settings.sync();
}
