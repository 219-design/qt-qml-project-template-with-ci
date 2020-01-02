//
// Copyright (c) 2020, 219 Design, LLC
// See LICENSE.txt
//
// https://www.219design.com
// Software | Electrical | Mechanical | Product Design
//
#ifndef PROJECT_APP_VIEW_MODEL_COLLECTION_H
#define PROJECT_APP_VIEW_MODEL_COLLECTION_H

#include <QQmlEngine>

#include <memory>

namespace project
{
class ViewModelCollection
{
public:
    ViewModelCollection();
    ~ViewModelCollection();

    ViewModelCollection( const ViewModelCollection& ) = delete;
    ViewModelCollection& operator=( const ViewModelCollection& ) = delete;

    void ExportContextPropertiesToQml( QQmlEngine* engine );

private:
    // std::unique_ptr<Navigation> m_navigation;
};
} // namespace project

#endif // PROJECT_APP_VIEW_MODEL_COLLECTION_H
