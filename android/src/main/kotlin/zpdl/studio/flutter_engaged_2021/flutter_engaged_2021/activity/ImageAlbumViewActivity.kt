package zpdl.studio.flutter_engaged_2021.flutter_engaged_2021.activity

import android.app.Activity
import android.graphics.Bitmap
import android.graphics.BitmapFactory
import android.os.Bundle
import android.view.MenuItem
import android.widget.ImageView
import kotlinx.coroutines.CoroutineScope
import kotlinx.coroutines.Dispatchers
import kotlinx.coroutines.async
import kotlinx.coroutines.launch
import zpdl.studio.flutter_engaged_2021.flutter_engaged_2021.ImageQuery
import zpdl.studio.flutter_engaged_2021.flutter_engaged_2021.R

class ImageAlbumViewActivity: Activity() {

    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        
        setContentView(R.layout.image_album_view_activity)
        actionBar?.title = "Image album viewer"
        actionBar?.setDisplayHomeAsUpEnabled(true)
        
        CoroutineScope(Dispatchers.Main).launch {
            val id = intent?.getLongExtra("id", 0) ?: 0

            var image: Bitmap? = null
            CoroutineScope(Dispatchers.Default).async {
                // background thread
                image = ImageQuery.readBytes(this@ImageAlbumViewActivity, id)?.let { 
                    BitmapFactory.decodeByteArray(it, 0, it.size)
                }
            }.await()

            image?.let {
                findViewById<ImageView>(R.id.image_album_view_activity_image_view)?.setImageBitmap(it)
            }
        }
    }
    
    override fun onOptionsItemSelected(item: MenuItem): Boolean =
            when (item.itemId) {
                android.R.id.home -> {
                    onBackPressed()
                    true
                }
                else -> super.onOptionsItemSelected(item)
            }
}