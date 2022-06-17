//
// Copyright (c) 2020, 219 Design, LLC
// See LICENSE.txt
//
// https://www.219design.com
// Software | Electrical | Mechanical | Product Design
//
#ifndef PROJ_LIB_QML_LIST_PROPERTY_H
#define PROJ_LIB_QML_LIST_PROPERTY_H

#include <QQmlListProperty>
#include <QSharedPointer>

#include <limits>
#include <memory>
#include <utility>
#include <vector>

namespace project
{
namespace internal
{
template <typename T>
T* GetPointer( T* ptr )
{
    return ptr;
}

template <typename T>
T* GetPointer( T& ptr )
{
    return &ptr;
}

template <typename T>
T* GetPointer( std::unique_ptr<T>& ptr )
{
    return ptr.get();
}

template <typename T>
T* GetPointer( std::shared_ptr<T>& ptr )
{
    return ptr.get();
}

template <typename T>
T* GetPointer( QSharedPointer<T>& ptr )
{
    return ptr.get();
}

template <typename T, typename Collection>
class QmlListHelper
{
public:
    static int ItemCount( QQmlListProperty<T>* property )
    {
        auto* items = reinterpret_cast<Collection*>( property->data );
        return static_cast<int>( items->size() );
    }

    static T* ItemAt( QQmlListProperty<T>* property, int index )
    {
        auto* items = reinterpret_cast<Collection*>( property->data );
        auto* item = GetPointer( items->at( index ) );

        static_assert(
            std::is_base_of<
                T, typename std::remove_pointer<decltype( item )>::type>::value,
            "Can only create QQmlListProperty<T> from classes derived from T" );

        return item;
    }
};

} // namespace internal

template <typename T, typename Collection>
QQmlListProperty<T> MakeQmlListProperty( QObject* owner, Collection* items )
{
    return QQmlListProperty<T>( owner, items,
        &internal::QmlListHelper<T, Collection>::ItemCount,
        &internal::QmlListHelper<T, Collection>::ItemAt );
}

} // namespace project

#endif // PROJ_LIB_QML_LIST_PROPERTY_H
