{ lib
, buildPythonPackage
, pythonOlder
, fetchPypi
, dataclasses-json
, pycryptodome
, setuptools
, pytest-asyncio
, pytest-cases
, pytestCheckHook
}:

buildPythonPackage rec {
  pname = "pysiaalarm";
  version = "3.0.1";

  disabled = pythonOlder "3.8";

  src = fetchPypi {
    inherit pname version;
    sha256 = "sha256-96LSD1jL4Za7HF9vgplImeY57EQ9qa/hOdjQ/PPBq4A=";
  };

  postPatch = ''
    substituteInPlace setup.cfg \
      --replace "==" ">="
    substituteInPlace pytest.ini \
      --replace "--cov pysiaalarm --cov-report term-missing" ""
  '';

  propagatedBuildInputs = [
    dataclasses-json
    pycryptodome
    setuptools
  ];

  checkInputs = [
    pytest-asyncio
    pytest-cases
    pytestCheckHook
  ];

  pythonImportsCheck = [
    "pysiaalarm"
    "pysiaalarm.aio"
  ];

  meta = with lib; {
    description = "Python package for creating a client that talks with SIA-based alarm systems";
    homepage = "https://github.com/eavanvalkenburg/pysiaalarm";
    license = licenses.mit;
    maintainers = with maintainers; [ dotlambda ];
  };
}
