package com.example.helloworld

import android.os.Bundle
import android.widget.Button
import android.widget.EditText
import android.widget.Toast
import androidx.appcompat.app.AppCompatActivity
import okhttp3.MediaType.Companion.toMediaTypeOrNull
import okhttp3.OkHttpClient
import okhttp3.Request
import okhttp3.RequestBody
import org.json.JSONObject
import kotlin.concurrent.thread

class MainActivity : AppCompatActivity() {
    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        setContentView(R.layout.activity_main)

        val editUser = findViewById<EditText>(R.id.editUser)
        val btnSave = findViewById<Button>(R.id.btnSave)
        val btnClose = findViewById<Button>(R.id.btnClose)

        btnSave.setOnClickListener {
            val name = editUser.text.toString().trim()
            if (name.isEmpty()) {
                Toast.makeText(this, "Please enter a name", Toast.LENGTH_SHORT).show()
                return@setOnClickListener
            }
            // perform network call on background thread
            thread {
                try {
                    val client = OkHttpClient()
                    val json = JSONObject()
                    json.put("name", name)
                    val mediaType = "application/json; charset=utf-8".toMediaTypeOrNull()
                    val body = RequestBody.create(mediaType, json.toString())
                    // Use 10.0.2.2 for emulator to reach host
                    val request = Request.Builder()
                        .url("http://10.0.2.2:3000/api/users")
                        .post(body)
                        .build()
                    val resp = client.newCall(request).execute()
                    val code = resp.code
                    runOnUiThread {
                        if (code == 200) {
                            Toast.makeText(this, "Saved", Toast.LENGTH_SHORT).show()
                            editUser.setText("")
                        } else {
                            Toast.makeText(this, "Save failed: $code", Toast.LENGTH_SHORT).show()
                        }
                    }
                } catch (e: Exception) {
                    e.printStackTrace()
                    runOnUiThread {
                        Toast.makeText(this, "Network error: ${e.message}", Toast.LENGTH_SHORT).show()
                    }
                }
            }
        }

        btnClose.setOnClickListener {
            finishAffinity()
        }
    }
}
