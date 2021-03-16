package zpdl.studio.flutter_engaged_2021.flutter_engaged_2021.activity

import android.Manifest
import android.app.Activity
import android.content.Intent
import android.graphics.Bitmap
import android.os.Bundle
import android.view.LayoutInflater
import android.view.MenuItem
import android.view.View
import android.view.ViewGroup
import android.widget.ImageView
import androidx.recyclerview.widget.GridLayoutManager
import androidx.recyclerview.widget.RecyclerView
import kotlinx.coroutines.CoroutineScope
import kotlinx.coroutines.Dispatchers
import kotlinx.coroutines.async
import kotlinx.coroutines.launch
import zpdl.studio.flutter_engaged_2021.flutter_engaged_2021.ImageQuery
import zpdl.studio.flutter_engaged_2021.flutter_engaged_2021.PluginImage
import zpdl.studio.flutter_engaged_2021.flutter_engaged_2021.R

class ImageAlbumActivity: Activity() {

    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        
        setContentView(R.layout.image_album_activity)
        actionBar?.title = "Image album by new screen"
        actionBar?.setDisplayHomeAsUpEnabled(true)

        requestPermissions(arrayOf(Manifest.permission.READ_EXTERNAL_STORAGE), 0x00)
    }

    override fun onRequestPermissionsResult(requestCode: Int, permissions: Array<out String>, grantResults: IntArray) {
        if(requestCode == 0x00) {
            CoroutineScope(Dispatchers.Main).launch {
                var images = mutableListOf<PluginImage>()
                CoroutineScope(Dispatchers.Default).async {
                    images = ImageQuery.getImages(this@ImageAlbumActivity)
                }.await()

                findViewById<RecyclerView>(R.id.image_album_activity_recycler_view).apply {
                    layoutManager = GridLayoutManager(this@ImageAlbumActivity, 4)
                    setHasFixedSize(true)
                    adapter = ImageAlbumAdapter(images)
                }
            }
        } else {
            super.onRequestPermissionsResult(requestCode, permissions, grantResults)
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

    inner class ViewHolder(view: View) : RecyclerView.ViewHolder(view) {
        val image: ImageView = view.findViewById(R.id.image_album_image_view)
    }

    inner class ImageAlbumAdapter(private val list: MutableList<PluginImage>): RecyclerView.Adapter<ViewHolder>() {

        override fun onCreateViewHolder(parent: ViewGroup, viewType: Int): ViewHolder {
            val view = LayoutInflater.from(parent.context)
                    .inflate(R.layout.image_album_image, parent, false)

            return ViewHolder(view)
        }

        override fun getItemCount(): Int = list.size

        override fun onBindViewHolder(holder: ViewHolder, position: Int) {
            CoroutineScope(Dispatchers.Main).launch {
                holder.image.setImageDrawable(null)
                var image: Bitmap? = null
                CoroutineScope(Dispatchers.Default).async {
                    // background thread
                    image = ImageQuery.getThumbnail(holder.itemView.context, list[position].id)
                }.await()

                image?.let {
                    holder.image.setImageBitmap(it)
                }

                holder.image.setOnClickListener {
                    this@ImageAlbumActivity.startActivity(
                            Intent(this@ImageAlbumActivity, ImageAlbumViewActivity::class.java).apply {
                                putExtra("id", list[position].id)
                            }
                    )
                }
            }
        }
    }
}

