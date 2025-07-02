<template>
  <div class="px-2">
    <el-tabs v-model="activeTab" @tab-click="handleTabClick">
      <el-tab-pane v-for="tab in tabs" :key="tab.name" :label="tab.label" :name="tab.name" />
    </el-tabs>
    <router-view />
  </div>
</template>

<script setup lang="ts">
import { ref } from 'vue'
import { useRouter } from 'vue-router'
import { ElTabs, ElTabPane } from 'element-plus'

const router = useRouter()
const activeTab = ref('icon-manager')

const tabs = [
  { label: '图标管理', name: 'icon-manager' },
  { label: 'SVG预览', name: 'svg-preview' },
  { label: '图片预览', name: 'download-ico' }
]

const handleTabClick = (tab: any): void => {
  router.push(`/${tab.props.name}`)
}
</script>