package com.pklein.bookmemo

import android.content.Context
import android.content.Intent
import android.content.SharedPreferences
import android.net.Uri
import android.widget.RemoteViews
import android.widget.RemoteViewsService
import es.antonborri.home_widget.HomeWidgetPlugin
import org.json.JSONArray


class WidgetDataProvider(context: Context, intent: Intent?) :
    RemoteViewsService.RemoteViewsFactory {
    var mListTitleView: MutableList<String> = ArrayList()
    var mListInfoView: MutableList<String> = ArrayList()
    var mListIdsView: MutableList<Int> = ArrayList()
    var mContext: Context = context

    override fun onCreate() {
        initData()
    }

    override fun onDataSetChanged() {
        initData()
    }

    override fun onDestroy() {}

    override fun getCount(): Int {
        return mListTitleView.size
    }

    override fun getViewAt(position: Int): RemoteViews {
        val view = RemoteViews(
            mContext.packageName,
            R.layout.row
        )
        view.setTextViewText(R.id.widgetTitle, mListTitleView[position])
        view.setTextViewText(R.id.widgetInfo, mListInfoView[position])

        val mIntent = Intent(mContext, MainActivity::class.java)
        mIntent.data = Uri.parse("bookMemo://updatebook?id=${mListIdsView[position]}")
        view.setOnClickFillInIntent(R.id.widgetRow, mIntent)

        return view
    }

    override fun getLoadingView(): RemoteViews? {
        return null
    }

    override fun getViewTypeCount(): Int {
        return 1
    }

    override fun getItemId(position: Int): Long {
        return position.toLong()
    }

    override fun hasStableIds(): Boolean {
        return true
    }

    private fun initData() {
        val data: SharedPreferences = HomeWidgetPlugin.getData(mContext)
        val bookTitles = data.getString("bookTitles", "")
        val bookInfos = data.getString("bookInfos", "")
        val bookIds = data.getString("bookIds", "")
        val listTitlesStr = JSONArray(bookTitles)
        val listInfosStr = JSONArray(bookInfos)
        val listIdsStr = JSONArray(bookIds)
        mListTitleView.clear()
        mListInfoView.clear()
        mListIdsView.clear()
        for (i in 0 until listTitlesStr.length()) {
            mListTitleView.add(listTitlesStr.getString(i))
            mListInfoView.add(listInfosStr.getString(i))
            mListIdsView.add(listIdsStr.getInt(i))
        }
    }
}