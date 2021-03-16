package zpdl.studio.flutter_engaged_2021.flutter_engaged_2021.platform_view

import android.content.Context
import android.graphics.Bitmap
import android.util.AttributeSet
import android.view.LayoutInflater
import android.view.View
import android.view.ViewGroup
import android.widget.FrameLayout
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

/** CameraView */
class ImageAlbumView : FrameLayout {

    private var listener: ImageAlbumViewListener? = null
    private val recyclerView: RecyclerView = RecyclerView(context)

    constructor(context: Context): this(context, null)

    constructor(context: Context, attrs: AttributeSet?): this(context, attrs, 0)

    constructor(context: Context, attrs: AttributeSet?, defStyleAttr: Int = 0): super(context, attrs, defStyleAttr)
    
    init {
        addView(recyclerView, LayoutParams(ViewGroup.LayoutParams.MATCH_PARENT, ViewGroup.LayoutParams.MATCH_PARENT))
    }
    
    fun setOnListener(listener: ImageAlbumViewListener?) {
        this.listener = listener
    }

    fun init() {
        CoroutineScope(Dispatchers.Main).launch {
            var images = mutableListOf<PluginImage>()
            CoroutineScope(Dispatchers.Default).async {
                images = ImageQuery.getImages(context)
            }.await()

            recyclerView.apply {
                layoutManager = GridLayoutManager(context, 4)
                setHasFixedSize(true)
                adapter = ImageAlbumAdapter(images)
            }
        }
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
                    listener?.onPluginImage(list[position])
                }
            }
        }
    }
}
