import { createRouter, createWebHashHistory } from 'vue-router';
import IconManager from '../components/IconManager.vue';
import svgPreview from '../components/svgPreview.vue';
import downLoadIco from '../components/downLoadIco.vue';

const routes = [
  { path: '/', component: IconManager },
  { path: '/icon-manager', component: IconManager },
  { path: '/svg-preview', component: svgPreview },
  { path: '/download-ico', component: downLoadIco },
];

const router = createRouter({
  history: createWebHashHistory(),
  routes,
});

export default router;