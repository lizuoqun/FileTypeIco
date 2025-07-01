<template>
  <div class="px-2">
    <el-tabs v-model="activeTab" @tab-click="handleTabClick">
      <el-tab-pane v-for="tab in tabs" :key="tab.name" :label="tab.label" :name="tab.name" />
    </el-tabs>
    <router-view />
  </div>
</template>

<script setup>
import { ref } from 'vue'
import { useRouter } from 'vue-router'
import { ElTabs, ElTabPane } from 'element-plus'

const router = useRouter()
const activeTab = ref('icon-manager')

const tabs = [
  { label: '图标管理', name: 'icon-manager' },
  { label: 'SVG预览', name: 'svg-preview' }
]

const handleTabClick = (tab) => {
  router.push(`/${tab.props.name}`)
}
</script>