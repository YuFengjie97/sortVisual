<script lang="jsx">
import { ref, watch } from "vue"
import { height } from "tailwindcss/defaultTheme"
export default {
  props: {
    arr: {
      type: Array,
      default: () => [1]
    },
  },
  setup(props) {
    console.log("grid props", props)
    let min = 0
    let max = 0

    function setM() {
      min = Math.min(...props.arr)
      max = Math.max(...props.arr)
    }

    function getHeight(val) {
      const minH = 30
      const maxH = 400
      const valH = (maxH / max) * val
      return valH < minH ? minH : valH
    }

    watch(
      () => props.arr,
      (val) => {
        setM()
        console.log(val)
      }
    )
    return () => (
      <div class="grid">
        {props.arr.map((item) => {
          const height = parseInt(getHeight(item))
          console.log(height)
          return <div style={{height: `${height}px`}} class="item">{item}</div>
        })}
      </div>
    )
  },
}
</script>

<style lang="less" scoped>
.grid {
  display: grid;
  grid-template-columns: repeat(auto-fill, 30px);
  grid-template-rows: 400px;
  justify-items: center;
  align-items: end;
  gap: 4px;
  border: 1px solid #000;
  .item {
    background: red;
    min-width: 20px;
    width: 20px;
    text-align: center;
  }
}
</style>
