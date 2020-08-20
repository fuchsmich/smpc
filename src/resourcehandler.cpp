#include "resourcehandler.h"

ResourceHandler::ResourceHandler(QObject *parent) :
    QObject(parent)
{
    m_haveResource = false;
    m_resourceSet = new ResourcePolicy::ResourceSet("player", 0, false, true);
    m_resourceSet->addResourceObject(new ResourcePolicy::ScaleButtonResource);
    connect(m_resourceSet, SIGNAL(resourcesGranted(QList<ResourcePolicy::ResourceType>)), this, SLOT(resourceAcquiredHandler(QList<ResourcePolicy::ResourceType>)));
    connect(m_resourceSet, SIGNAL(lostResources()), this, SLOT(resourceLostHandler()));
}

void ResourceHandler::acquire()
{
    m_resourceSet->acquire();
}

void ResourceHandler::release()
{
    m_resourceSet->release();
    m_haveResource = false;
    emit haveResourceChanged();
}

void ResourceHandler::resourceAcquiredHandler(const QList<ResourcePolicy::ResourceType> &)
{
    m_haveResource = true;
    emit haveResourceChanged();
}

void ResourceHandler::resourceLostHandler()
{
    m_haveResource = false;
    emit haveResourceChanged();
}

bool ResourceHandler::haveResource()
{
    return m_haveResource;
}
