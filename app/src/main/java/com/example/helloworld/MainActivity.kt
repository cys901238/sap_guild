package com.example.helloworld

import android.os.Bundle
import android.widget.Button
import android.widget.EditText
import android.widget.TextView
import android.widget.Toast
import androidx.appcompat.app.AppCompatActivity
import okhttp3.MediaType.Companion.toMediaTypeOrNull
import okhttp3.OkHttpClient
import okhttp3.Request
import okhttp3.RequestBody.Companion.toRequestBody
import org.json.JSONObject
import kotlin.concurrent.thread

class MainActivity : AppCompatActivity() {
    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        setContentView(R.layout.activity_main)

        val editUserid = findViewById<EditText>(R.id.editUserid)
        val btnSave = findViewById<Button>(R.id.btnSave)
        val btnClose = findViewById<Button>(R.id.btnClose)
        val textStatus = findViewById<TextView>(R.id.textStatus)

        btnSave.setOnClickListener {
            val userid = editUserid.text.toString().trim()
            if (userid.isEmpty()) {
                Toast.makeText(this, "사용자 ID를 입력하세요", Toast.LENGTH_SHORT).show()
                return@setOnClickListener
            }
            textStatus.text = "저장 중..."
            // 네트워크 작업은 별도 스레드에서 수행
            thread {
                try {
                    // 기본: 에뮬레이터에서 개발시 10.0.2.2 사용
                    val baseUrl = "http://10.0.2.2:3000"
                    val client = OkHttpClient()
                    val json = JSONObject().put("userid", userid).toString()
                    val body = json.toRequestBody("application/json; charset=utf-8".toMediaTypeOrNull())
                    val req = Request.Builder().url(baseUrl + "/api/users").post(body).build()
                    val resp = client.newCall(req).execute()
                    val success = resp.isSuccessful
                    runOnUiThread {
                        if (success) {
                            textStatus.text = "저장 완료"
                            Toast.makeText(this, "저장 성공", Toast.LENGTH_SHORT).show()
                        } else {
                            textStatus.text = "저장 실패: ${resp.code}"
                            Toast.makeText(this, "저장 실패: ${resp.code}", Toast.LENGTH_SHORT).show()
                        }
                    }
                } catch (e: Exception) {
                    e.printStackTrace()
                    runOnUiThread {
                        textStatus.text = "예외 발생: ${e.message}"
                        Toast.makeText(this, "네트워크 오류", Toast.LENGTH_SHORT).show()
                    }
                }
            }
        }

        btnClose.setOnClickListener {
            finish()
        }
    }
}
