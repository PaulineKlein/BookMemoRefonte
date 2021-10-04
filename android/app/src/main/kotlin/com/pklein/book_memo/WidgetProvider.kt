package com.pklein.book_memo

import android.app.PendingIntent
import android.appwidget.AppWidgetManager
import android.appwidget.AppWidgetProvider
import android.content.Context
import android.content.Intent
import android.net.Uri
import android.widget.RemoteViews
import es.antonborri.home_widget.HomeWidgetLaunchIntent

const val UPDATE_LIST = "UPDATE_LIST"

class WidgetProvider : AppWidgetProvider() {

    override fun onUpdate(
        context: Context,
        appWidgetManager: AppWidgetManager,
        appWidgetIds: IntArray
    ) {
        for (appWidgetId in appWidgetIds) {
            //Update all instances of this widget//
            updateAppWidget(context, appWidgetManager, appWidgetId)
        }
        super.onUpdate(context, appWidgetManager, appWidgetIds)
    }

    override fun onEnabled(context: Context?) {
        // Enter relevant functionality for when the first widget is created
    }

    override fun onDisabled(context: Context?) {
        // Enter relevant functionality for when the last widget is disabled
    }

    private fun updateAppWidget(
        context: Context,
        appWidgetManager: AppWidgetManager,
        appWidgetId: Int
    ) {
        //Instantiate the RemoteViews object//
        val views = RemoteViews(context.packageName, R.layout.widget)
        setRemoteAdapter(context, views)

        val clickIntent = Intent(context, MainActivity::class.java)
        clickIntent.action = HomeWidgetLaunchIntent.HOME_WIDGET_LAUNCH_ACTION
         val pendingIntent =
            PendingIntent.getActivity(context, 0, clickIntent, PendingIntent.FLAG_UPDATE_CURRENT)
        views.setPendingIntentTemplate(R.id.widget_list, pendingIntent)

        //Request that the AppWidgetManager updates the application widget//
        appWidgetManager.notifyAppWidgetViewDataChanged(
            appWidgetId,
            R.id.widget_list
        ) // update listView
        appWidgetManager.updateAppWidget(appWidgetId, views)
    }

    private fun setRemoteAdapter(context: Context, views: RemoteViews) {
        views.setRemoteAdapter(
            R.id.widget_list,
            Intent(context, WidgetService::class.java)
        )
    }
}