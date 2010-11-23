
local seed_name="p5_Math_CDF"
local deps=("perl-5.12.2")
local p_module="Math::CDF"

do_install()
{
  check_deps ${deps[@]}
  before_install $seed_name
  cpan_install $p_module
  after_install $recipe
}

do_remove()
{
  before_remove $seed_name
  cpan_remove $p_module
  after_remove $seed_name
}

source "$MAIN_DIR/lib/case.sh"
