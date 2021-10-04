package com.pklein.book_memo

import android.content.Intent
import android.widget.RemoteViewsService

class WidgetService : RemoteViewsService() {

    override fun onGetViewFactory(intent: Intent?): RemoteViewsFactory {
        return WidgetDataProvider(this, intent)
    }
}