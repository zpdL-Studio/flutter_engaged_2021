package zpdl.studio.flutter_engaged_2021.flutter_engaged_2021

import android.content.ContentResolver
import android.content.ContentUris
import android.content.Context
import android.graphics.Bitmap
import android.os.Bundle
import android.provider.MediaStore
import android.util.Size

class ImageQuery {
    companion object {
        fun getImages(context: Context?): MutableList<PluginImage> {
            val cursor = context?.contentResolver?.query(
                    MediaStore.Images.Media.EXTERNAL_CONTENT_URI,
                    arrayOf(
                            MediaStore.Images.Media._ID,
                            MediaStore.Images.Media.DISPLAY_NAME
                    ),
                    null,
//                    Bundle().apply {
//                        putStringArray(
//                                ContentResolver.QUERY_ARG_SORT_COLUMNS,
//                                arrayOf(MediaStore.Images.Media.DATE_MODIFIED)
//                        )
//                        putInt(
//                                ContentResolver.QUERY_ARG_SORT_DIRECTION,
//                                ContentResolver.QUERY_SORT_DIRECTION_DESCENDING
//                        )
//                    },
                    null
            )
            val results = mutableListOf<PluginImage>()
            cursor?.let { c ->
                val columnIndexID = c.getColumnIndexOrThrow(MediaStore.Images.Media._ID)
                val columnIndexDisplayName = c.getColumnIndexOrThrow(MediaStore.Images.Media.DISPLAY_NAME)
                while (c.moveToNext()) {
                    results.add(PluginImage(
                            id = cursor.getLong(columnIndexID),
                            displayName = cursor.getString(columnIndexDisplayName) ?: ""
                    ))
                }
            }

            cursor?.close()
            return results
        }

        fun getThumbnail(context: Context?, id: Long, width: Int = 256, height: Int = 256): Bitmap? =
                context?.contentResolver?.loadThumbnail(
                        ContentUris.withAppendedId(MediaStore.Images.Media.EXTERNAL_CONTENT_URI, id),
                        Size(width, height),
                        null
                )
        
        fun readBytes(context: Context?, id: Long): ByteArray? {
            context?.contentResolver?.openInputStream(ContentUris.withAppendedId(MediaStore.Images.Media.EXTERNAL_CONTENT_URI, id))?.use {
                try {
                    return it.readBytes()
                } catch (e: Exception) {
                } finally {
                    it.close()
                }
            }

            return null
        }
    }
}

data class PluginImage(
        val id: Long,
        val displayName: String
) {
    fun toMap(): Map<String, *> = hashMapOf(
            "id" to id,
            "displayName" to displayName
    )
}