#ifndef RESOURCEHANDLER_H
#define RESOURCEHANDLER_H

#include <QObject>
#include <policy/resource-set.h>

class ResourceHandler : public QObject
{
    Q_OBJECT
    Q_PROPERTY(bool haveResource READ haveResource NOTIFY haveResourceChanged)

public:
    explicit ResourceHandler(QObject *parent = 0);
    bool haveResource();

signals:
    void haveResourceChanged();

private slots:
    void resourceAcquiredHandler(const QList<ResourcePolicy::ResourceType>&);
    void resourceLostHandler();

public slots:
    void acquire();
    void release();

private:
    ResourcePolicy::ResourceSet *m_resourceSet;
    bool m_haveResource;
};

#endif // RESOURCEHANDLER_H
